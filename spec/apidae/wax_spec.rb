# encoding: utf-8

require 'spec_helper'

require 'apidae/wax'

shared_examples_for "wax_body" do

  describe 'body' do
    its(:body) { should == subject }
    its(:body) { should == Base64.decode64(Apidae::Wax::MOLDS[described_class.name.split('::').last.to_sym].first) }
  end

end

shared_examples_for "wax_push" do

  describe '<<' do
    it 'should push content to the body' do
      (subject << 'plop').should == subject
      subject.should include('plop')
      subject.body.should include('plop')
    end
  end

end

describe Apidae::Wax::Assemblage do
  it_should_behave_like "wax_body"
  it_should_behave_like "wax_push"

  [:title, :head].each do |part|
    its(part) { should == subject }

    it "should be able to push content to #{part}" do
      (subject.send(part) << 'plop').should include('plop')
      subject.should include("plop</#{part}>")
      (subject.send(part) << 'plap').should include("plopplap</#{part}>")
      (subject.send(part) << 'plip').should == subject
    end
  end
end

describe Apidae::Wax::Link do
  it "should render link" do
    (described_class.new << ['plip', 'plap', 'plop']).should == '<a href="/plip/plap">plop</a>'
  end
end

describe Apidae::Wax::Image do
  it "should render an image tag" do
    (described_class.new << 'plop.jpg').should == '<img src="/read/plop.jpg">'
  end
end

describe Apidae::Wax::Style do
  it_should_behave_like "wax_body"
end

Apidae::Wax.constants.reject { |c| [:MOLDS, :Assemblage, :Style].include? c }.each do |constant|
  describe Apidae::Wax.const_get(constant) do
    it_should_behave_like "wax_body"
    it_should_behave_like "wax_push"
  end
end
