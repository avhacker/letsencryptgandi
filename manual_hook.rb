#!/usr/bin/env ruby

require 'resolv'

$SSL_HOST = ENV['SSL_HOST']
$GANDI_DOMAIN = ENV['GANDI_DOMAIN']
$GANDI_API_KEY = ENV['GANDI_API_KEY']
$acme_name = "_acme-challenge"
if !$SSL_HOST.empty?
  $acme_name = "_acme-challenge.%s" % [$SSL_HOST]
end
$acme_domain = "%s.%s" % [$acme_name, $GANDI_DOMAIN]

def setup_dns(domain, txt_challenge)
  resolved = false;
  singleLoop = false;
  dns = Resolv::DNS.new;
  add_cmd = 'curl -s -i -D- -X POST -H "Content-Type: application/json" -H "X-Api-Key: $GANDI_API_KEY" -d \'{"rrset_name": "%s","rrset_type": "TXT","rrset_ttl": 300,"rrset_values": ["%s"]}\' https://dns.beta.gandi.net/api/v5/domains/%s/records' % [$acme_name, txt_challenge, $GANDI_DOMAIN]
  del_cmd = 'curl -s -i -X DELETE -H "Content-Type: application/json" -H "X-Api-Key: $GANDI_API_KEY" https://dns.beta.gandi.net/api/v5/domains/%s/records/%s' % [$acme_name, $GANDI_DOMAIN]
  puts 'delete old DNS record: %s' % [$acme_domain]
  puts del_cmd
  puts %x[ #{del_cmd} ]
  sleep 5;
  puts 'create new TXT DNS record: %s -> %s' % [$acme_domain, txt_challenge]
  puts add_cmd
  %x[ #{add_cmd} ]
  sleep 15;

  puts "Checking for pre-existing TXT record for the domain: \'#{$acme_domain}\'."

  until resolved
    dns.each_resource($acme_domain, Resolv::DNS::Resource::IN::TXT) { |resp|
     if resp.strings[0] == txt_challenge
       puts "Found #{resp.strings[0]}. match."
       resolved = true;
     else
       puts "Found #{resp.strings[0]}. no match."
     end
    }

    if !resolved
     puts "Didn't find a match for #{txt_challenge}";
     puts "Waiting to retry...";
     sleep 30;
    end
  end
end

def delete_dns(domain, txt_challenge)
  puts "Challenge complete. Leave TXT record in place to allow easier future refreshes."
  del_cmd = 'curl -s -i -X DELETE -H "Content-Type: application/json" -H "X-Api-Key: $GANDI_API_KEY" https://dns.beta.gandi.net/api/v5/domains/%s/records/%s' % [$GANDI_DOMAIN, $acme_name]
  %x[ #{del_cmd} ]
end

if __FILE__ == $0
  hook_stage = ARGV[0]
  domain = ARGV[1]
  txt_challenge = ARGV[3]

  # puts hook_stage
  # puts domain
  # puts txt_challenge

  if hook_stage == "deploy_challenge"
    setup_dns(domain, txt_challenge)
  elsif hook_stage == "clean_challenge"
    delete_dns(domain, txt_challenge)
  end

end
