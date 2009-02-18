package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;
use DateTime::Format::Human::Duration;

template 'index.html' => page { title => "Jitter" } content {
    outs h1 {'jitter'}
    outs show('create_jit_widget');
    ol {
        attr { class => 'jits' };
        my $jits = Jitter::Model::JitCollection->new;
        $jits->unlimit();
        $jits->order_by( column => 'datetime_jitted', order => 'DES' );
        while ( my $jit = $jits->next ) {
            show( 'jit', $jit );
        }
    }
};

private template 'jit' => sub {
    my ( $self, $jit ) = @_;
    li {
        attr { class => 'jit' };
        outs $jit->body;
        span {
            attr { class => 'meta' };
            my $span = DateTime::Format::Human::Duration->new();
            outs $span->format_duration_between( $jit->datetime_jitted,
                DateTime->now );
            outs ' ago from jitter';
        };
    };
};

private template 'create_jit_widget' => sub {
    my $action = Jifty->web->new_action( class => 'CreateJit' );
    form {
        form_next_page url => '/';
        render_action $action;
        form_submit( label => 'Jit it!' );
    };
};

1;
