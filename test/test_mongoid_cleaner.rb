require 'minitest_helper'

describe MongoidCleaner do
  it 'has a version number' do
    refute_nil ::MongoidCleaner::VERSION
  end

  it 'can be configured' do
    MongoidCleaner.available_strategies.each do |strategy|
      MongoidCleaner.strategy = strategy
    end
  end

  it 'can be configured with symbol' do
    MongoidCleaner.available_strategies.map(&:to_sym).each do |strategy|
      MongoidCleaner.strategy = strategy
    end
  end

  it 'fail with wrong strategy' do
    assert_raises MongoidCleaner::UnknownStrategySpecified do
      MongoidCleaner.strategy = :test
    end
  end

  describe 'drop' do
    before do
      MongoidCleaner.strategy = 'drop', {}
      User.create(login: 'test')
      Article.create(title: 'test')
    end

    it 'collections' do
      MongoidCleaner.collections.size.must_equal 2
      MongoidCleaner.clean
      MongoidCleaner.collections.size.must_equal 0
    end
  end

  describe 'truncate' do
    before do
      MongoidCleaner.strategy = 'truncate', {}
      User.create(login: 'test')
      Article.create(title: 'test')
    end

    it 'collections' do
      MongoidCleaner.collections.size.must_equal 2
      MongoidCleaner.clean
      MongoidCleaner.collections.size.must_equal 2
      User.where(login: 'test').one.must_equal nil
      Article.where(title: 'test').one.must_equal nil
    end
  end

  describe 'only' do
    describe 'truncate' do
      before do
        MongoidCleaner.strategy = 'truncate', { only: %w(users) }
        User.create(login: 'test')
        Article.create(title: 'test')
      end

      it 'selected collections' do
        MongoidCleaner.clean
        User.where(login: 'test').one.must_equal nil
        Article.where(title: 'test').one.wont_equal nil
      end
    end

    describe 'drop' do
      before do
        MongoidCleaner.strategy = 'drop', { only: %w(users) }
        User.create(login: 'test')
        Article.create(title: 'test')
      end

      it 'selected collections' do
        MongoidCleaner.clean
        MongoidCleaner.collections.size.must_equal 1
        MongoidCleaner.collections.wont_include 'users'
      end
    end
  end

  describe 'except' do
    describe 'truncate' do
      before do
        MongoidCleaner.strategy = 'truncate', { except: %w(users) }
        User.create(login: 'test')
        Article.create(title: 'test')
      end

      it 'selected collections' do
        MongoidCleaner.clean
        User.where(login: 'test').one.wont_equal nil
        Article.where(title: 'test').one.must_equal nil
      end
    end

    describe 'drop' do
      before do
        MongoidCleaner.strategy = 'drop', { except: %w(users) }
        User.create(login: 'test')
        Article.create(title: 'test')
      end

      it 'selected collections' do
        MongoidCleaner.clean
        MongoidCleaner.collections.size.must_equal 1
        MongoidCleaner.collections.must_include 'users'
      end
    end
  end
end
