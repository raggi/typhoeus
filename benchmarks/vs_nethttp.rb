require 'typhoeus'
require 'thread'
require 'open-uri'
require 'benchmark'
include Benchmark

calls = 20
@klass = Class.new do
  include Typhoeus
end

Typhoeus.init_easy_object_pool

q = Queue.new
threads = Array.new(calls) { Thread.new { q.pop.call } }

benchmark do |t|
  t.report("net/http") do
    responses = []

    calls.times do |i|
      q << lambda { open("http://127.0.0.1:3000/#{i}").read }
      responses << threads[i]
    end

    responses.each {|r| raise unless r.value == "whatever"}
  end

  t.report("typhoeus") do
    responses = []

    calls.times do |i|
      responses << @klass.get("http://127.0.0.1:3000/#{i}")
    end

    responses.each {|r| raise unless r.body == "whatever"}
  end
end
