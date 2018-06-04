# frozen_string_literal: true

require 'awspec'
require 'aws-sdk'
require 'rhcl'


#/Users/ramanmishra/Documents/learning/teraform/my_terraform_module/test/fixtures/tf_module/main.tf
# should strive to randomize the region for more robust testing

state_file = './terraform.tfstate.d/kitchen-terraform-default-aws/terraform.tfstate'
tf_state = JSON.parse(File.open(state_file).read)
outputs =  tf_state['modules'][0]['outputs']
region = outputs['region']['value']
ENV['AWS_REGION'] = region

tags = outputs['Environments']['value']
user_tag = tags['Owner']
environment_tag = tags['Environment']
vpc_name = outputs['vpc']['value']
zone_names = outputs['availability_zones']['value']

describe vpc(vpc_name.to_s) do
  it { should exist }
  it { should be_available }
  it { should have_tag('Name').value(vpc_name.to_s) }
  it { should have_tag('Owner').value(user_tag.to_s) }
  it { should have_tag('Environment').value(environment_tag.to_s) }
  it { should have_route_table("#{vpc_name}-public") }
  zone_names.each do |az|
    it { should have_route_table("#{vpc_name}-private-#{az}") }
  end
end

zone_names.each do |az|
  describe subnet("#{vpc_name}-public-#{az}") do
    it { should exist }
    it { should be_available }
    it { should belong_to_vpc(vpc_name.to_s) }
    it { should have_tag('Name').value("#{vpc_name}-public-#{az}") }
    it { should have_tag('Owner').value(user_tag.to_s) }
    it { should have_tag('Environment').value(environment_tag.to_s) }
  end
end
