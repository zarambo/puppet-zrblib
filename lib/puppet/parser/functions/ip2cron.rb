# provides a "random" value to cron based on the last byte of the machine IP address.
# used to avoid starting a certain cron job at the same time on all servers.
# if used with no parameters, it will return a single value between 0-59
# first argument is the occurrence within a timeframe, for example if you want it to run 2 times per hour
# the second argument is the timeframe, by default its 60 minutes, but it could also be 24 hours etc
# ohadlevy@gmail.com
#
# example usage
# ip2cron()     - returns one value between 0..59
# ip2cron(2)    - returns an array of two values between 0..59
# ip2cron(2,24) - returns an array of two values between 0..23

module Puppet::Parser::Functions
    newfunction(:ip2cron, :type => :rvalue) do |args|
        occours = args[0].to_i || 1
        scope   = args[1].to_i || 60
        ip      = lookupvar('ipaddress').split('.')[3].to_i
        base    = ip % scope
        if occours == 1
            base
        else
            (1..occours).map {|i| (base - (scope / occours * i)) % scope }.sort
        end
    end
end