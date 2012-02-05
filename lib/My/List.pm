package My::List;

use strict;
use warnings;

use base qw(My::Aggregate);
use My::ItemIterator;
use My::ListItem;

sub new {
    my $class = shift;
    my $this = {
	items => { 0 => {next_id => -1} }, ## Listのヘッダ
	index => 1, ## Listの要素id
	last_id => 0 ## Listの末尾の要素id
	};
    
    return bless $this, $class;
}

sub append {
    my $this = shift;
    my $value = shift;
    
    my $item = My::ListItem->new({value => $value});
    ## 要素を追加
    $this->{items}->{$this->{index}} = {
	next_id => -1, ## 次の要素id
	item => $item,
    };
    ## 末尾（前)の要素の next_id を更新
    $this->{items}->{$this->{last_id}}->{next_id} = $this->{index};
    
    ## 末尾のidを更新
    $this->{last_id} = $this->{index};
    $this->{index}++;
}

sub iterator {
    my $this = shift;
    return My::ItemIterator->new($this);
}


1;
