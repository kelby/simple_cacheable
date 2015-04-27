require 'uri'
require "cacheable/caches"
require "cacheable/keys"
require "cacheable/expiry"
require "cacheable/model_fetch"
require "cacheable/railtie"
require 'active_support/concern'

module Cacheable
  extend ::ActiveSupport::Concern
  extend ModelFetch

  included do
    extend  Cacheable::Caches
    include Cacheable::Keys
    include Cacheable::Expiry

    class_attribute   :cached_key,
                      :cached_indices,
                      :cached_methods,
                      :cached_class_methods,
                      :cached_associations
  end

  def self.escape_punctuation(string)
    string.sub(/\?\Z/, '_query').sub(/!\Z/, '_bang')
  end

  def self.rails4?
    ActiveRecord::VERSION::MAJOR >= 4
  end

  module ClassMethods
    def model_cache(&block)
      instance_exec &block
    end
  end
end
