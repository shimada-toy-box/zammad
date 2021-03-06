# Copyright (C) 2012-2016 Zammad Foundation, http://zammad-foundation.org/

module Channel::Filter::OutOfOfficeCheck

  def self.run(_channel, mail)

    mail[ :'x-zammad-out-of-office' ] = false

    # check ms out of office characteristics
    if mail[ :'x-auto-response-suppress' ]
      return if !mail[ :'x-auto-response-suppress' ].match?(/all/i)
      return if !mail[ :'x-ms-exchange-inbox-rules-loop' ]

      mail[ :'x-zammad-out-of-office' ] = true
      return
    end

    if mail[ :'auto-submitted' ]

      # check zimbra out of office characteristics
      if mail[ :'auto-submitted' ].match?(/vacation/i)
        mail[ :'x-zammad-out-of-office' ] = true
      end

      # check cloud out of office characteristics
      if mail[ :'auto-submitted' ].match?(/auto-replied;\sowner-email=/i)
        mail[ :'x-zammad-out-of-office' ] = true
      end

      # gmail check out of office characteristics
      if mail[ :'auto-submitted' ] =~ /auto-replied/i && mail[ :subject ] =~ /vacation/i
        mail[ :'x-zammad-out-of-office' ] = true
      end

      return
    end

    true
  end

end
