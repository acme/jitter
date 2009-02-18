package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;

template 'index.html' => page { title => "Jitter" } content {
    b {"The Index"};
    a { attr { href => '/post/' } 'Write a jit' }
    h1 {'All Posts'}
    ul {
        my $posts = Jitter::Model::PostCollection->new;
        $posts->unlimit();
        while ( my $p = $posts->next ) {
            li { $p->jit };
        }
    }
};

template 'post' => page { title => 'Foo' } content {
    my $action = Jifty->web->new_action( class => 'CreatePost' );
    form {
        form_next_page url => '/';
        render_action $action;
        form_submit( label => _('Add post') );
    }
};

1;
