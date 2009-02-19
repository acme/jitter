package Jitter::Model::Jit;
use strict;
use warnings;
use Jifty::DBI::Schema;

use Jitter::Record schema {
    column
        body => type is 'text',
        label is 'Jit',
        is mandatory,
        max_length is 160,
        render_as 'Textarea',
        hints is 'Make it short and sweet',
        since '0.0.1';
    column
        datetime_jitted => type is 'datetime',
        is mandatory,
        render_as 'Unrendered',
        input_filters are 'Jifty::DBI::Filter::DateTime',
        default is defer { DateTime->now },
        since '0.0.1';
    column
        posted_by => render_as 'Unrendered',
        default is defer { Jifty->web->current_user->id },
        references Jitter::Model::User;
};

sub current_user_can {
    my ( $self, $action, $attr ) = @_;

    # warn "$self $action $attr";
    return 1;
}

1;
