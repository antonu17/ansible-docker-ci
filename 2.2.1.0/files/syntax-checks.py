#!/usr/bin/env python
"""syntax-check

Usage:
    syntax-check.py --base <base-dir> [--config <file>] [--inventory <inv1,inv2,inv3>]
    syntax-check.py -h

Examples:
    syntax-check -b feature/x123 -d /home/ahelal/plays

Options:
  -b, --base <base-dir>             Play dir path [default: ./]
  -c, --config <file>               Config file [default: syntax-checks.yml].
  -i, --inventory <inv>             Inventory files i.e. staging.ini,tools.ini [default: staging.ini]
  -h, --help                        Show this screen and exit.

"""

import re
import fnmatch
import subprocess
import yaml
import ConfigParser
import os
from docopt import docopt
from StringIO import StringIO

class Syntax(object):
    def __init__(self, arguments):
        ## Arugment
        self.config = self.read_yaml(arguments.get("--config"))
        self.base_dir = arguments.get("--base")
        self.inventory = arguments.get("--inventory").split(",")

        ## Config
        self.syntax_command = self.config.get("ansible_bin", "ansible-playbook")
        self.exclude_groups = self.config.get("exclude_group", [])
        self.exclude_groups = r'|'.join([fnmatch.translate(x) for x in self.exclude_groups]) or r'$.'

        self.play_dir = os.path.join( self.base_dir, "plays")
        self.results_groups = []
        self.groups_per_stage = []

        if self.config.get("ansible_bin_resovle", False):
            p  = self.syntax_command = self.run_command("printf %s" % self.syntax_command)
            out, err = p.communicate()
            p_status = p.wait()
            if p_status != 0:
                print "Error in resolving command: exit code '%s' error: '%s'" %(p_status, err)
                exit(1)
            self.syntax_command = out

    @staticmethod
    def read_yaml( yaml_file):
        try:
            with open(yaml_file, 'r') as stream:
                yaml_data = yaml.load(stream)
            return yaml_data
        except yaml.scanner.ScannerError as e:
            print "Parse error in parsing yaml file %s" % e
            exit(1)

    @staticmethod
    def run_command(command,cwd=None, shell=True):
        if not shell:
            command = command.split(" ")
        p = subprocess.Popen(command, cwd=cwd, stdout=subprocess.PIPE,stderr=subprocess.PIPE, shell=shell)
        return p

    def syntax_command_run(self, inventory, play):
        inventory = os.path.join(self.base_dir, inventory)
        command = "%s --syntax-check -i %s %s"%(self.syntax_command, inventory, play)
        p = self.run_command(command=command, cwd=self.play_dir, shell=True)
        return p

    def _run_syntax_check(self):
        # for loop in our dic
        for stage in self.groups_per_stage:
            stage_name = stage.get("name")
            groups = stage.get("groups", [])
            print("> Stage: '%s' # of Groups '%s'" % (stage_name, len(groups)))
            for group in groups:
                p = self.syntax_command_run(stage_name, group + ".yml")
                single_result = dict()
                (single_result["output"], single_result["err"]) = p.communicate()
                single_result["p_status"] = p.wait()
                single_result["group"] = group
                single_result["Stage"] = stage_name
                self.results_groups.append(single_result)

    @staticmethod
    def _check_file_perm(f):
        if not os.access(f,os.R_OK) and not os.path.isfile(f):
            print "File does not exists or you dont have permission to '%s'" % f
            exit(1)

    def _read_ini(self, ini_file):
        path = os.path.join(self.base_dir,ini_file)
        self._check_file_perm(path)
        config = ConfigParser.SafeConfigParser(allow_no_value=True)
        config.read(path)
        local_groups_per_stage = {"name": ini_file}
        groups = config.sections()
        local_groups_per_stage["groups"] = [f for f in groups if not re.match(self.exclude_groups, f)]
        self.groups_per_stage.append(local_groups_per_stage)

    def main(self):
        for inventory in self.inventory:
            self._read_ini(inventory)
        #self._read_ini("/Users/ahelal/GDrive/Projects/automation/staging.ini")
        self._run_syntax_check()
        exit_code = 0
        for group in self.results_groups:
            group_status = group.get("p_status")
            print "%s:%s" % (group_status,group.get("group"))

            if group_status != 0:
                exit_code = 1
                print " > %s" % group.get("err")
        exit(exit_code)

if __name__ == '__main__':
    arguments = docopt(__doc__)
    Syntax(arguments).main()

