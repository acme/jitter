use strict;
use warnings;

package Jitter::Model::Post;
use Jifty::DBI::Schema;

use Jitter::Record schema {
    column
        title => type is 'text',
        label is 'Title',
        default is 'Untitled post';

    column
        body => type is 'text',
        label is 'Content',
        render_as 'Textarea';

};

# Your model-specific methods go here.

1;

