package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;

template 'index.html' => page { title => "Jitter" } content {
    a { attr { href => '/post/' } 'Write a jit' }
    h1 {'All Jits'}
    ol {
        attr { class => 'jits' };
        my $jits = Jitter::Model::JitCollection->new;
        $jits->unlimit();
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
            '5 minutes ago';
        };

    };
};

template 'post' => page { title => 'Foo' } content {
    my $action = Jifty->web->new_action( class => 'CreateJit' );
    form {
        form_next_page url => '/';
        render_action $action;
        form_submit( label => _('Jit it!') );
    }
};

1;
