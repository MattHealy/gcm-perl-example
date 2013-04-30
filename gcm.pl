#!/usr/bin/perl

  use strict;
  use warnings;

  use WWW::Google::Cloud::Messaging;

  my $api_key = 'YOUR_API_KEY_HERE';
  my $gcm = WWW::Google::Cloud::Messaging->new(api_key => $api_key);

  my $reg_id = 'YOUR_REG_ID_HERE';

  my $res = $gcm->send({
      registration_ids => [ $reg_id ],
      data             => {
        message => 'Testing 1 2 3',
      },
  });

  die $res->error unless $res->is_success;

  my $results = $res->results;

  while (my $result = $results->next) {
      my $reg_id = $result->target_reg_id;
      if ($result->is_success) {
          sprintf 'message_id: %s, reg_id: %s',
              $result->message_id, $reg_id;
      }
      else {
          warn sprintf 'error: %s, reg_id: %s',
              $result->error, $reg_id;
      }

      if ($result->has_canonical_id) {
          sprintf 'reg_id %s is old! refreshed reg_id is %s',$reg_id, $result->registration_id;;
      }
  }


