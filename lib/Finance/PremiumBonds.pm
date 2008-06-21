package Finance::PremiumBonds;

# $Id$

use 5.005000;
use strict;
use warnings;
use WWW::Mechanize;
use Carp;

our $VERSION = '0.03';
our $checker_url  = 'http://www.nsandi.com/products/pb/haveYouWon.jsp';
our $agent_string = "Perl/Finance::PremiumBonds $VERSION";
our $holdernumfield = 'holderNumber';

sub has_won {

    my $holdernum = shift
        or carp "No holder number supplied" and return;

    
    my $mech = WWW::Mechanize->new( agent => $agent_string );
    
    $mech->get($checker_url);
    
    if (!$mech->success) {
        warn "Initial request failed - " . $mech->response->status_line;
        return;
    }
  

    my $form = $mech->form_with_fields($holdernumfield);
    if (!$form) {
        warn "Failed to find form containing $holdernum field "
            . " - perhaps NS+I website has been changed";
        return;
    }
    
    $mech->field($holdernumfield, $holdernum);
    #$mech->field('check', 'go');
    $mech->submit()
        or  warn "Unable to submit lookup - " . $mech->response->status_line 
        and return;
    warn "Content: " . $mech->content . "\n";
    if ($mech->content =~ /holder number must be 10 numbers/msi
     || $mech->content =~ /check your holder's number - it is not valid/msi) 
    {
        carp "Holder number not recognised by NS+I";
        return;
    }

    # TODO: it'd be nice to actually detect a winning response, rather than
    # the lack of a losing response - but I need a holder's number which has
    # actually won in order to see what the response is :)
    return ($mech->content =~ m{not this time.*better luck next month}msi)
        ? 0 : 1;
}



1;
__END__

=head1 NAME

Finance::PremiumBonds - Perl extension to check Premium Bond holder's numbers

=head1 SYNOPSIS

  use Finance::PremiumBonds;
  
  if (defined(my $won = Finance::PremiumBonds::has_won($holder_number))) 
  {
      print "Looks like you " . ($won)? 'may have won' : 'have not won';
  } else {
      warn "An error occurred.";
  }
  

=head1 DESCRIPTION

Quick way to look up a Premium Bond holder's number on the National Savings
and Investments website to determine whether the holder has won any prizes
recently.

Currently I don't have a list of possible responses to look for (and they
could change at any time anyway) so the module will return true if it
receives a non-error response which doesn't include the recognised negative
response text.  If it ever reports incorrect results to you, please do
let me know so I can update it.

=head1 FUNCTIONS

=over 4

=item has_won($holder_number)

Checks whether $holder_number has won any prizes recently.  Returns 1 if
it looks like you've won, 0 if you haven't, or undef if it failed to check.

=back


=head1 AUTHOR

David Precious, E<lt>davidp@preshweb.co.ukE<gt>


=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by David Precious

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=head1 LIMITATIONS

Currently, the module detects lack of a recognised "losing" response rather
than the presence of a winning response; without a holder's number which has
won something, I can't see what the winning responses look like.  Maybe my
meagre Premium Bonds investment will win something one day, then I can update
this module :)


=cut
