package Jitter::Model::User;
use strict;
use warnings;
use Jifty::DBI::Schema;

use Jitter::Record schema {
    column userpic   => is Userpic;
    column gender    => type is 'text', !is writable, default is 'female';
    column birthdate => type is 'date';
    column
        bio => type is 'text',
        label is 'Who are you?',
        legend is 'Tell the world a little bit about yourself.',
        render as 'Textarea';
    since '0.0.2';
};

# Import columns: name, email and email_confirmed
use Jifty::Plugin::User::Mixin::Model::User;

# Import columns: password, auth_token
use Jifty::Plugin::Authentication::Password::Mixin::Model::User;

sub current_user_can {
    my ( $self, $action, $attr ) = @_;

    # warn "$self $action $attr";

    return 1 if $action eq 'read';
    return 1 if ( $action eq 'read' && $self->id == $self->current_user->id );
    return $self->SUPER::current_user_can( $action, $attr );
}

1;
