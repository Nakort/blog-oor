require 'minitest/autorun'
require 'active_model'
require_relative '../spec_helper_lite'
require_relative '../../app/models/post'
describe Post do

  subject{ Post.new}

  it "is not valid with a blank title" do
    [nil, "", " "].each do |bad_title|
      subject.title = bad_title
      refute subject.valid?
    end
  end

  it "is valid with a non-blank title" do
    subject.title = "x"
    assert subject.valid?
  end 

  it "starts with blank attributes" do
    subject.title.must_be_nil
    subject.body.must_be_nil
  end

  it "supports reading and writing a title" do
    subject.title = "foo"
    subject.title.must_equal "foo"
  end

  it "supports reading and writing a post body" do
    subject.body = "foo"
    subject.body.must_equal "foo"
  end

  it "supports setting attributes in the initializer" do
    it = Post.new(title: "mytitle", body: "mybody")
    it.title.must_equal "mytitle"
    it.body.must_equal "mybody"
  end

  it "supports reading and writing a blog reference" do
    blog = Object.new
    subject.blog = blog
    subject.blog.must_equal blog
  end

  describe "#publish" do
    let(:blog){MiniTest::Mock.new}
    before do
      subject.blog = blog
    end

    after do
      blog.verify
    end

    it "adds the post to the blog" do
      stub(subject).valid?(){ true}
      blog.expect :add_entry, nil, [subject]
      subject.publish
    end

    describe "given an invalid post" do
      before do subject.title = nil end

      it "wont add the post to the blog" do
        dont_allow(blog).add_entry
        subject.publish
      end

      it "returns false" do
        refute(subject.publish)
      end
    end
  end

  describe "#pubdate" do
    let(:clock) { stub!}
    let(:now) { DateTime.parse("2011-09-11T02:56") }

    describe "before publishing" do
       it "is blank" do
         subject.pubdate.must_be_nil
       end
     end

    describe "after publishing" do
      before do
        stub(subject).valid?(){ true}
        stub(clock).now(){ now }
        subject.blog = stub!
        subject.publish(clock)
      end

      it "is the current time" do
        subject.pubdate.must_equal(now)
      end
      it "is a datetime" do
         subject.pubdate.class.must_equal(DateTime)
       end
     end
   end
end
