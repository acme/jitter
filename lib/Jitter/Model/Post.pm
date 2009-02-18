use strict;
use warnings;

package Jitter::Model::Post;
use Jifty::DBI::Schema;

use Jitter::Record schema {
    column
        jit => type is 'text',
        label is 'Title',
        is mandatory,
        max_length is 160,
        render_as 'Textarea',
        hints is 'Make it short and sweet';
};

1;

