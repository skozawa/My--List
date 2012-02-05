package My::ItemIterator;

use base qw(My::Iterator);

sub new {
    my $class = shift;
    my $list = shift;
    my $this = {list => $list, index => 0};
    
    return bless $this, $class;
}

sub has_next {
    my $this = shift;
    ## 次の要素があるか
    if($this->{list}->{items}->{$this->{index}}->{next_id} != -1) {
	return 1;
    } else {
	return 0;
    }
}

sub next {
    my $this = shift;
    
    my $cur_item = $this->{list}->{items}->{$this->{index}};
    my $next_item = $this->{list}->{items}->{$cur_item->{next_id}};
    
    $this->{index} = $cur_item->{next_id};
    
    return $next_item->{item};
}

sub init {
    my $this = shift;
    $this->{index} = 0;
}

1;
