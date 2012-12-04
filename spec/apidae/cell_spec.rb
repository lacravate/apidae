# encoding: utf-8

require 'spec_helper'

describe Apidae::Cell do

  context 'a realtive path' do

    subject { described_class.new 'lib/apidae.rb' }

    describe 'string value' do
      it 'should be equal to what new argument was' do
        subject.to_s.should == 'lib/apidae.rb'
      end
    end

    describe 'interface' do
      it 'should at least respond to the following' do
        [:file?, :basename, :extname, :read, :dirname, :absolute_name].all? do |meth|
          subject.respond_to?(meth)
        end
      end
    end

    describe 'values' do
      its(:file?) { should be_true }
      its('basename.to_s') { should == 'apidae.rb' }
      its(:extname) { should == '.rb' }
      its(:read) { should == File.read('lib/apidae.rb') }
      its('dirname.to_s') { should == 'lib' }
      its('absolute_name') { should == File.join(Dir.pwd, 'lib/apidae.rb') }
      its('mime') { should include('text/') }
      its('linker') { should == 'show_link' }
    end
  end

  context 'an absolute directory path' do

    subject { described_class.new File.join(Dir.pwd, 'lib').to_s }

    describe 'string value' do
      it 'should be equal to what new argument was' do
        subject.to_s.should == 'lib'
      end
    end

    describe 'values' do
      its(:file?) { should be_false }
      its('basename.to_s') { should == 'lib' }
      its(:extname) { should == '' }
      its('dirname.to_s') { should == '.' }
      its('absolute_name') { should == File.join(Dir.pwd, 'lib') }
      its('linker') { should == 'browse_link' }
    end
  end

end
