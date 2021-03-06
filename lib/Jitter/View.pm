package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;
use DateTime::Format::Human::Duration;

template 'index.html' => page { title => "Jitter" } content {
    show('mytitle');
    show('timeago');
    render_region( path => '/create_jit_widget', name => 'create' );
    ol {
        attr { class => 'jits' };
        Jifty->web->region(
            name => 'jits',
            path => '/jits',
        );
    };
};

private template 'timeago' => sub {
    outs_raw q|
<script type="text/javascript">
jQuery(document).ready(function() {
  jQuery('abbr[class*=timeago]').timeago();
});
</script>
|;
};

private template 'mytitle' => sub {
    my ( $self, $title ) = @_;
    $title ||= 'jitter';
    h1 {
        a {
            attr { href => '/' } img {
                attr { src => '/static/images/jitter.png', border => 0 };
            }
        };
        outs $title;
    };
};

template 'user' => page { title => 'Jitter for ' . get('name') } content {
    show( 'mytitle', 'jitter for ' . get('name') );
    ol {
        attr { class => 'jits' };
        Jifty->web->region(
            name      => 'jits',
            path      => '/jits',
            arguments => { name => get('name') },
        );
    };
};

template 'jits' => sub {
    my $page = get('page') || 1;
    my $name = get('name');
    my $jits = Jitter::Model::JitCollection->new;
    if ($name) {
        my $user = Jitter::Model::User->new;
        $user->load_by_cols( name => $name );
        $jits->limit( column => 'posted_by', value => $user );
    } else {
        $jits->unlimit();
    }
    $jits->set_page_info(
        current_page => $page,
        per_page     => 5,
    );
    $jits->order_by( column => 'datetime_jitted', order => 'DES' );
    while ( my $jit = $jits->next ) {
        show( 'jit', $jit );
    }
    div {
        attr { class => 'bottom-nav' };
        div {
            attr { id => 'pagination', class => 'pagination' };
            if ( $jits->pager->next_page ) {
                Jifty->web->link(
                    label   => 'Older',
                    class   => 'section_links',
                    rel     => 'prev',
                    onclick => { args => { page => $jits->pager->next_page } }
                );
            }
            if ( $jits->pager->previous_page ) {
                Jifty->web->link(
                    label => 'Newer',
                    class => 'section_links',
                    rel   => 'next',
                    onclick =>
                        { args => { page => $jits->pager->previous_page } }
                );
            }
        }
    }
};

template 'onejit' => sub {
    my $self = shift;
    my $id   = get('id');
    my $jit  = Jitter::Model::Jit->new;
    $jit->load($id);
    show( 'jit', $jit );
    show('timeago');
};

private template 'jit' => sub {
    my ( $self, $jit ) = @_;
    li {
        attr { class => 'jit' };
        strong {
            a {
                attr { href => '/user/' . $jit->posted_by->name };
                $jit->posted_by->name;
            }
        };
        span {
            attr { class => 'entry-content' } outs $jit->body;
        };
        span {
            attr { class => 'meta' };
            my $span = DateTime::Format::Human::Duration->new();
            abbr {
                attr {
                    class => 'timeago',
                    title => $jit->datetime_jitted->ymd . 'T'
                        . $jit->datetime_jitted->hms . 'Z',
                };
                outs $span->format_duration_between( $jit->datetime_jitted,
                    DateTime->now );
                outs ' ago';
            };
            outs ' from jitter';
        };
    };
};

template 'create_jit_widget' => sub {
    my $create = Jifty->web->new_action( class => 'CreateJit' );
    form {
        form_next_page url => '/';
        render_action $create;
        form_submit(
            label   => 'Jit it!',
            onclick => [
                { refresh_self => 1 },
                {   submit  => $create,
                    region  => 'jits',
                    prepend => '/onejit',
                    effect  => 'SlideDown',
                    beforeclick =>
                        "jQuery('.jit:last').slideUp('normal', function() { jQuery(this).remove(); } );",
                    args => { id => { result_of => $create, name => 'id' } },
                }
            ],
        );
    };
};

1;
