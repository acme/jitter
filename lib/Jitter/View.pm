package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;
use DateTime::Format::Human::Duration;

template 'index.html' => page { title => "Jitter" } content {
    h1 {'jitter'};
    show('create_jit_widget');
    ol {
        attr { class => 'jits' };
        Jifty->web->region(
            name => 'jits',
            path => '/jits',
        );
    };
};

template 'jits' => sub {
    my $page = get('page') || 1;
    my $jits = Jitter::Model::JitCollection->new;
    $jits->unlimit();
    $jits->set_page_info(
        current_page => $page,
        per_page     => 5,
    );
    $jits->order_by( column => 'datetime_jitted', order => 'DES' );
    while ( my $jit = $jits->next ) {
        show( 'jit', $jit );
    }
    if ( $jits->pager->previous_page ) {
        Jifty->web->link(
            label   => "Newer jits",
            onclick => { args => { page => $jits->pager->previous_page } }
        );
    }
    if ( $jits->pager->next_page ) {
        Jifty->web->link(
            label   => "Older jits",
            onclick => { args => { page => $jits->pager->next_page } }
        );
    }
};

template 'onejit' => sub {
    my $self = shift;
    my $id   = get('id');
    my $jit  = Jitter::Model::Jit->new;
    $jit->load($id);
    show( 'jit', $jit );
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
    my $create = Jifty->web->new_action( class => 'CreateJit' );
    form {
        form_next_page url => '/';
        render_action $create;
        form_submit(
            label   => 'Jit it!',
            onclick => {
                submit       => $create,
                refresh_self => 1,
                region       => 'jits',
                prepend      => '/onejit',
                args => { id => { result_of => $create, name => 'id' } },
            },
        );
    };
};

1;
