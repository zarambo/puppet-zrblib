#
# bool2ensure.rb
#
# This define return present/absent accroding to the boolean value passed
#
module Puppet::Parser::Functions
  newfunction(:bool2ensure, :type => :rvalue, :doc => <<-EOS
This converts any input similar to a boolean to the string present or absent.
If a second and third parameter can be set to translate the boolean to other
values. e.g.:
  bool2ensure(true, 'running', 'stopped')
    EOS
  ) do |arguments|

    raise(Puppet::ParseError, "bool2ensure(): Wrong number of arguments " +
      "given (#{arguments.size} for 1)") if arguments.size < 1

    string = arguments[0]
    if arguments.size > 1
      enable = arguments[1]
    else
      enable = "present"
    end
    if arguments.size > 2
      disable = arguments[2]
    else
      disable = 'absent'
    end

    result = case string
      when false then disable
      when true then enable
      when /^$/, '' then disable
      when /^(1|t|y|true|yes)$/  then enable
      when /^(0|f|n|false|no)$/  then disable
      when /^(undef|undefined)$/ then enable
      when /^present$/ then enable
      when /^absent$/ then disable
      else
        raise(Puppet::ParseError, 'bool2ensure(): Unknown type of boolean given')
    end

    return result
  end
end

# vim: set ts=2 sw=2 et :
