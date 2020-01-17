require 'net/http'
require 'net/https'
require 'openssl'
require 'uri'
require 'json'
require 'cgi'
load 'domain.rb'

# Ruby script for monitoring SSL certificates 
# Autor : jhsilva 

domains = []
domains_to_expire = []

# C.A. List of domains to verify and endpoints
domains.push(Domain.new("Api-Production","api.segurosfalabella.com"))
domains.push(Domain.new("Api-Staging","api-staging.segurosfalabella.com"))
domains.push(Domain.new("web.segurosfalabella.com","web.segurosfalabella.com"))

puts '¿How many days do you want to check due dates?'
days_to_expire = Integer(gets) rescue false 

#Domains- Check SSL expirations and add to array domains_to_expire
if days_to_expire
  config_expiry_weeks = days_to_expire * 86400 # Expire before x days
  puts "--------------- SSL - Checking domains ------------------"
  for domain in domains
    begin
      puts "Name: "+domain.name
      puts "Domain: "+domain.url
      uri = URI::HTTPS.build(host: domain.url)
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true,:verify_mode => OpenSSL::SSL::VERIFY_PEER)
      cert = response.peer_cert
      puts "Expiration date: "+cert.not_after.to_s
      domain.expiration_date = cert.not_after
      if Time.now + config_expiry_weeks > cert.not_after
        domains_to_expire.push(Domain.new(domain.name,domain.url,domain.expiration_date.strftime("%d-%m-%Y")))
      end
    rescue StandardError => e 
      if e.message.include? "certificate verify failed"
          puts "Verification failed in "+domain.name 
      end
    end
    puts "---------------------------------------------------------"
  end

  domains_to_expire_sendgrid = domains_to_expire.collect { |item| {:name => item.name, :expirationdate => item.expiration_date} }
  puts "------------SSL -Domains to expire--------------------------"
  puts "SSL certs to expire in "+days_to_expire.to_s+" días."
  puts domains_to_expire_sendgrid

else
  puts "Funny!, Enter a number for the number of days :B"
end 

# Call API EMAIL for Sending alert message (domains_to_expire_sendgrid)
