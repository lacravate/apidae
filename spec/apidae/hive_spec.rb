# encoding: utf-8

require 'spec_helper'

describe Apidae::Hive do

  let(:browser) { Rack::Test::Session.new(Rack::MockSession.new(described_class)) }

  describe "routes" do
    it "should not respond to /" do
      browser.get '/'
      browser.last_response.status.should == 404
    end

    it "should not respond to /plop" do
      browser.get '/plop'
      browser.last_response.status.should == 404
    end

    it "should respond to /browse" do
      browser.get '/browse'
      browser.last_response.status.should == 200
    end

    it "should respond to /browse/" do
      browser.get '/browse/'
      browser.last_response.status.should == 200
    end

    it "should respond to /browse/lib" do
      browser.get '/browse/lib'
      browser.last_response.status.should == 200
    end

    it "should respond to /show/lib/apidae.rb" do
      browser.get '/show/lib/apidae.rb'
      browser.last_response.status.should == 200
    end

    it "should respond to /media/lib/apidae.rb" do
      browser.get '/media/lib/apidae.rb'
      browser.last_response.status.should == 200
    end

  end

  describe '/browse/' do
    it "should display all the designated root directory contents" do
      browser.get '/browse/'

      Dir['*'].all? { |content| browser.last_response.body.include? content }.should be_true
      browser.last_response.body.should include('Contents of /')
      browser.last_response.status.should eq 200
    end
  end

  describe '/browse/lib' do
    it "should display all the contents of url specified directory" do
      browser.get '/browse/lib'

      Dir['lib/*'].all? { |content| browser.last_response.body.include? File.basename(content) }.should be_true
      browser.last_response.body.should include('Parent directory')
      browser.last_response.body.should include('Contents of lib/')
      browser.last_response.status.should eq 200
    end
  end

  describe '/show/lib/apidae.rb' do
    it "should show the content of the url specified text file" do
      browser.get '/show/lib/apidae.rb'

      browser.last_response.body.should include('Parent directory')
      browser.last_response.body.should include('<p>apidae.rb</p>')
      browser.last_response.body.should include(File.read('lib/apidae.rb'))
      browser.last_response.status.should eq 200
    end
  end

  describe '/media/lib/apidae.rb' do
    it "should serve the url specified file contents" do
      browser.get '/media/lib/apidae.rb'

      browser.last_response.body.should == File.read('lib/apidae.rb')
      browser.last_response.status.should eq 200
    end
  end

end
