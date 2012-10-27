---
layout: post
title: "Rspec基础"
date: 2012-09-15 00:20
comments: true
categories: [Rspec]
---

RSpec是BDD(行为驱动测试)的一种测试框架。按照BDD理念，应该是先写一些行为用例场景，
运行测试用例，应该失败(Red),然后写实现代码，再次运行测试,让测试通过(Green),最后
重构代码，再运行测试用例,保证成功(Green)。

每次写的测试用例要针对粒度比较小的代码实现，然后去一步步实现代码。例如测试RoR中Controller
代码，要保证资源创建和保存这些涉及到数据库存取的action,要Mock这些数据，尽量少接触
数据库。

```ruby
@post = mock_model(Post, {
	:id => 1,
	:name => "Foo Bar"
})
```
和数据库这种松耦合的关系可以保证数据的灵活性(可以根据业务逻辑代码去mock数据)，以及
测试运行的效率。

写测试有一个好处就是构建使用用例，在测试的同时其实也是在告诉使用者，应该如何使用你写的
库或者工具。这个需要测试框架能够生成测试用例的文档，这一点Rspec可以实现。
<!--More-->
下面开始介绍一些Rspec如何测试.
首先安装依赖的gem

```
$> rvm --create use 1.9.2@rails326

$> gem install rspec ZenTest
```
创建一个rails项目
```
$> rails new forecaster
$> mkdir spec
$> vim spec/simple_spec.rb
```
然后在simple_spec.rb输入以下代码
```ruby
class Post
end

describe Post do
	it "should be awesome"
end
```
describe描述context的，这里表述的是class
然后运行这个spec
```
$> rspec spec/simple_spec.rb
*

Pending:
  Post should be awesome
    # Not yet implemented
    # ./spec/simple_spec.rb:5

Finished in 0.00022 seconds
1 example, 0 failures, 1 pending
```
说明上面的it没有实现完全
```
class Post
end

describe Post do
	it "should be awesome" do
		Post.new.should be_awesome
	end
end
```
should是一个断言，这里也可以使用should_not。接下来可以使用的是matcher
后面会介绍matcher的使用。这里运行一下
```
$> rspec spec/simple_spec.rb
F

Failures:

  1) Post should be awesome
     Failure/Error: Post.new.should be_awesome
     NoMethodError:
       undefined method `awesome?' for #<Post:0x0000010118bc38>
     # ./spec/simple_spec.rb:6:in `block (2 levels) in <top (required)>'

Finished in 0.03062 seconds
1 example, 1 failure

Failed examples:

rspec ./spec/simple_spec.rb:5 # Post should be awesome
```
这个说明Post的没有实现awesome?方法，should be_awesome被翻译成awesome?方法。
下面实现Post的实例方法:
```ruby
class Post
	def awesome?
		true
	end
end

describe Post do
	it "should be awesome" do
		Post.new.should be_awesome
	end
end
```
然后在运行测试:
```
$> rspec spec/simple_spec.rb
.

Finished in 0.00329 seconds
1 example, 0 failures
```
这就是一轮Red->Refactor->Green。
context的"it do"之间如果没有description,这个context也是会执行的。
```ruby
class Post
	def awesome?
		true
	end
end

class Book;end

describe Post do
	it "should be awesome" do
		Post.new.should be_awesome
	end

	it do
		Post.new.should be_awesome
	end

	it do
		Post.new.should_not be_an_instance_of(Book)
	end
end
```
```
$> rspec spec/simple_spec.rb --format h >> output.html
```
将测试结果文档化，并将内容输出到output.html文件中。be_an_instance_of是
一个matcher。

在这里可以看出每次运行一个example block(it...do)时，都要创建一个Post实例。Rspec提供了
before和after两个过滤器，在运行example之前或者之后运行before和after代码块，在这里可以
初始化或者善后一些处理操作。

before分为all和each，before(:all)是针对整个describe context，它只运行一次，这里是describe Post。
另外一个是before(:each),它是在每个example(spec)运行前都会执行的。before默认的也是each。下面重构一下
rspec测试代码:

```ruby
describe Post do

	before do
		@post = Post.new
	end

	it "should be awesome" do
		@post.should be_awesome
	end

	it do
		@post.should be_awesome
	end

	it do
		@post.should_not be_an_instance_of(Book)
	end
end
```

让我们再添加一个测试场景和响应的实现。
```ruby
class Post
	def awesome?
		true
	end

	def comments
		["Foo", "Bar"]
	end
end

class Book;end

describe Post do

	before do
		@post = Post.new
	end

	it "should be awesome" do
		@post.should be_awesome
	end

	it do
		@post.should be_awesome
	end

	it do
		@post.should_not be_an_instance_of(Book)
	end

	it do
		@post.should have(2).comments
	end
end
```
注意这里应该先写测试，然后运行测试，最后在实现代码，这就是一轮(Red->Refactor->Green)。
这里.should have(2)是一种matcher其实可以看成省略，那么就成了@post.comments。
想要查阅更多的Matcher信息，可以访问[https://www.relishapp.com/rspec](https://www.relishapp.com/rspec)。

下面介绍如何为Ruby on Rails安装Rspec相关的Gem
```
$> gem install rspec
$> gem install rspec-core
$> gem install rspec-expectations
$> gem install rspec-mocks
$> gem install rspec-rails
```

然后在Rails项目Gemfile添加以下代码
```
group :test, :development do
  gem "rspec-rails", "~> 2.11"
end
```
这样就可以保证rspec不会干扰production环境。然后在项目中初始化和生成spec目录:
```
$> rails g rspec:install
      create  .rspec
       exist  spec
      create  spec/spec_helper.rb
```
查阅rspec-rails文档[https://www.relishapp.com/rspec/rspec-rails/v/2-11/docs]https://www.relishapp.com/rspec/rspec-rails/v/2-11/docs
查看spec有哪些rake工具可以使用:
```
$> rake -T spec
rake spec              # Run all specs in spec directory (excluding plugin specs)
rake spec:controllers  # Run the code examples in spec/controllers
rake spec:helpers      # Run the code examples in spec/helpers
rake spec:lib          # Run the code examples in spec/lib
rake spec:mailers      # Run the code examples in spec/mailers
rake spec:models       # Run the code examples in spec/models
rake spec:rcov         # Run all specs with rcov
rake spec:requests     # Run the code examples in spec/requests
rake spec:routing      # Run the code examples in spec/routing
rake spec:views        # Run the code examples in spec/views
```
下面开始创建Rails model并尝试使用rspec测试
```
$> rails g scaffold Post title:string content:text
... ...
      invoke    rspec
      create      spec/controllers/posts_controller_spec.rb
      create      spec/views/posts/edit.html.erb_spec.rb
      create      spec/views/posts/index.html.erb_spec.rb
      create      spec/views/posts/new.html.erb_spec.rb
      create      spec/views/posts/show.html.erb_spec.rb
      create      spec/routing/posts_routing_spec.rb
      invoke      rspec
      create        spec/requests/posts_spec.rb
      invoke    helper
      create      app/helpers/posts_helper.rb
      invoke      rspec
      create        spec/helpers/posts_helper_spec.rb
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/posts.js.coffee
      invoke    scss
      create      app/assets/stylesheets/posts.css.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.css.scss
```
在spec目录中生成了controllers,helpers,models,requests,routing,views目录。
下面迁移数据库并拷贝到测试数据库:
```
$ rake db:migrate && rake db:test:prepare
```
然后去spec生成的目录中看看默认生成的rspec测试内容，这些是针对对应的RoR Component
测试。看一些spec_helper.rb
```ruby
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test' #这个是使用的是什么数据库，这里如果ENV["RAILS_ENV"] 存在就
#使用已经存在的，或者使用test
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #可以添加夹具测试数据
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
```
现在运行一下默认的测试
```
$> rake spec
$> rake spec:controllers #测试controllers
$> rake spec:models #测试models
$> rake spec:views #测试views
$> rake spec:helpers #测试helpers
```
开始写一些spec测试model
```ruby
require 'spec_helper'

describe Post do

  before do
  	@post = Post.new
  end

  it "should be valid" do
  	@post.should be_valid
  end
  
end
```
运行这个spec，发现能成功pass过去。再添加一些spec
```ruby
require 'spec_helper'

describe Post do

  before do
  	@post = Post.new
  end

  it "should be valid" do
  	@post.should be_valid
  end

  it do
  	@post.should have(1).error_on(:title)
  end

end
```
这次再运行测试发现运行失败，因为没有error。怎样才能让spec通过？
首先@post的title是nil。可以添加一些验证条件到post.rb中。
```ruby
class Post < ActiveRecord::Base
  attr_accessible :content, :title
  validates_presence_of :title
end
```
运行rake spec:models发现还是失败，因为第一个spec没有通过，通过修改post_spec.rb
```
require 'spec_helper'

describe Post do

  before do
  	@post = Post.new
  end

  it "should be valid" do
  	@post.title = "FooBar"
  	@post.should be_valid
  end

  it do
  	@post.should have(1).error_on(:title)
  end

end

```
在运行测试，通过。可以重构一些post_spec.rb
```ruby
require 'spec_helper'

module PostSpecHelper

	def valid_post_attributes
		{
			:title=>"FooBar Title"
		}
	end
end


describe Post do

  include PostSpecHelper

  before do
  	@post = Post.new
  end

  it "should be valid" do
  	@post.attributes = valid_post_attributes
  	@post.should be_valid
  end

  it do
  	@post.should have(1).error_on(:title)
  end

end
```
这样封装的好处是可以把case分类，并且重用。





















