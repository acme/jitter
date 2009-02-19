package Jitter::Dispatcher;
use strict;
use warnings;
use Jifty::Dispatcher -base;

before '*' => run {
    if ( Jifty->web->current_user->id ) {
        my $top = Jifty->web->navigation;
        $top->child( _('Pick!')   => url => '/pick' );
        $top->child( _('Choices') => url => '/choices' );
    } elsif ( $1 !~ /^login|^signup/ ) {
        tangent 'login';
    }
};

on 'user/*' => run {
    set( name => $1 );
    show 'user';
}

1;
