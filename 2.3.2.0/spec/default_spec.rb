require 'spec_helper'

build_image = true
image_id="6630ab15b473"
#image_id=false
IMAGE_TAG="dev"
describe "Dockerfile" do
  before(:all) do
    if build_image
      puts " will Build image  quay.io/hellofresh/logstash-docker:#{IMAGE_TAG}"
      image = Docker::Image.build_from_dir('.') do |v|
        if (log = JSON.parse(v)) && log.has_key?("stream")
          $stdout.puts log["stream"]
        end
      end
      image_id = image.id
      puts "built image is #{image_id}"
    else 
      puts "Using image supplied #{image_id}"
    end
    
    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image_id
  end
  #
  after(:all) do
     image.remove(:force => true) if build_image
     puts "Remove image" if build_image
  end

  describe command('python -V') do
    its(:stderr) { should match /Python 2.7/}
    its(:exit_status) { should eq 0 }
  end

  describe command('pip --version') do
    its(:exit_status) { should eq 0 }
  end

  describe command('ansible --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /2.0./}
  end

  describe command('ruby --version') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /2.0./}
  end

  describe command('bundler -v') do
    its(:exit_status) { should eq 0 }
  end

  describe command('ssh -V') do
    its(:exit_status) { should eq 0 }
  end
  #apt_packages = ['gcc', 'python2.7-dev', 'libffi-dev', 'libpng12-dev', 'libfreetype6-dev', 'libblas-dev', 'liblapack-dev', 'libatlas-base-dev', 'gfortran', 'libpq-dev', 'python-pip']
end
