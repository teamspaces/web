#http://mlomnicki.com/ruby/tricks-and-quirks/2011/02/10/ruby-tricks2.html

class Object
  def switch( hash )
    hash.each {|method, proc| return proc[] if send method }
    yield if block_given?
  end
end
