package My::ItemIterator;

use strict;
use warnings;

use base qw(My::Iterator);

sub new {
    my $class = shift;
    my $init = shift;
    my $this = {
	cur => $init,
	init => $init,
    };
    
    return bless $this, $class;
}

sub has_next {
    my $this = shift;
    ## 次の要素があるか
    if(defined $this->{cur}->{next}) {
	return 1;
    } else {
	return 0;
    }
}

sub next {
    my $this = shift;
    
    if(!defined $this->{cur}->{next}) {
	die 'Item has not next';
    }
    ## 次の要素に更新
    $this->{cur} = $this->{cur}->{next};
    return $this->{cur}->{item};
}

sub init {
    my $this = shift;
    $this->{cur} = $this->{init};
}

1;
