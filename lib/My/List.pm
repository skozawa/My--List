package My::List;

use strict;
use warnings;

use base qw(My::Aggregate);
use My::ItemIterator;
use My::ListItem;

sub new {
    my $class = shift;
    my $init = {item=>undef, next=>undef};
    my $this = {
	items => { init => $init }, ## Listのヘッダ
	pre => $init,
	index => 1, ## Listの要素id
    };
    
    return bless $this, $class;
}

sub append {
    my $this = shift;
    my $value = shift;
    
    my $item = My::ListItem->new({value => $value});
    ## 要素を追加
    $this->{items}->{$this->{index}} = {
	item => $item,
    };
    ## 前の要素の next を更新
    $this->{pre}->{next} = $this->{items}->{$this->{index}};
    $this->{pre} = $this->{items}->{$this->{index}};
        
    ## 要素idを更新
    $this->{index}++;
}

sub iterator {
    my $this = shift;
    return My::ItemIterator->new($this->{items}->{init});
}


1;
