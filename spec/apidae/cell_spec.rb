# encoding: utf-8

require 'spec_helper'

require 'apidae/cell'

describe Apidae::Cell do

  context 'a file' do

    subject { described_class.new 'lib/apidae.rb' }

    its(:mime) { should include('text/') }
    its(:slashed) { should == subject }

  end

  context 'a directory' do

    subject { described_class.join(Dir.pwd, 'lib').with_relative_root(Dir.pwd, 'lib') }

    its(:mime) { should == "application/octet-stream" } # which is preposterous, but...
    its(:slashed) { should == [Dir.pwd, '/', 'lib', '/'].join }

    it "should not prefix its relative path by a '.'" do
      subject.relative!
      subject.should == ''
    end

  end

end
