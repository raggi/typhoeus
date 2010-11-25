#!/usr/bin/env rackup -s thin
module App
  def self.call(env)
    EM.add_timer(0.5) { env['async.callback'][[200, {}, 'whatever']] }
    throw :async
  end
end

run App