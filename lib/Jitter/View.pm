package Jitter::View;
use strict;
use warnings;
use Jifty::View::Declare -base;

template 'index.html' => page { title => "Jitter" } content {
    { title is 'Some Title' }
    b {"The Index"};
    h1 { 'All Posts' }
    dl {
        my $posts = Jitter::Model::PostCollection->new;
        $posts->unlimit();
        while (my $p = $posts->next) {
            dt { $p->title }
            dd { $p->body }
        }
    }
};

template 'post' => sub {
    my $action = Jifty->web->new_action( class => 'CreatePost' );
    form {
        render_param ($action => 'title', focus => 1);
        render_param ($action => 'body' );
        form_submit( label => _('Add post') );
    }
};

1;
