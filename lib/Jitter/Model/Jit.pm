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
        hints is 'Make it short and sweet';
};

1;

