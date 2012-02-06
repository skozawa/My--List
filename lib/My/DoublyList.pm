package My::DoublyList;

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
	last => $init,
	index => 1 ## Listの要素id
	};
    
    return bless $this, $class;
}

## 指定した要素の後ろに要素を追加
## 指定しない場合は末尾に追加
sub append {
    my $this = shift;
    my ($value, $target_id) = @_;
    
    my $pre = $this->{last};
    if(defined $target_id && defined $this->{items}->{$target_id}) {
	$pre = $this->{items}->{$target_id};
    }
    
    $this->append_item($value, $pre);
}

## index番目の要素の後ろに要素を追加
sub append_by_index {
    my $this = shift;
    my ($value, $index) = @_;
    
    return if($index < 0 || $index > scalar(keys %{$this->{items}}));
    
    my $cur_item = $this->{items}->{init};
    for ( 0 .. $index ) {
	$cur_item = $cur_item->{next};
    }
    
    $this->append_item($value, $cur_item);
}


sub append_item {
    my $this = shift;
    my ($value, $pre) = @_;
    
    my $item = My::ListItem->new({value => $value});
    ## 要素を追加
    $this->{items}->{$this->{index}} = {
	item => $item,
	pre => $pre,
	next => $pre->{next},
    };
    
    ## 次の要素の更新
    ## 末尾に挿入した場合
    if(!defined $pre->{next}) {
	$this->{last} = $this->{items}->{$this->{index}};
    }
    ## 要素間に挿入した場合
    else{
	$pre->{next}->{pre} = $this->{items}->{$this->{index}};
    }

    ## 前の要素の更新
    $pre->{next} = $this->{items}->{$this->{index}};
        
    ## 要素idを更新
    $this->{index}++;
}

## 指定した要素を削除
sub remove {
    my $this = shift;
    my $target_id = shift;
    
    return if($target_id eq "init" || !defined $this->{items}->{$target_id});
    
    my $cur_item = $this->{items}->{$target_id};
    ## 前後の要素を更新
    $cur_item->{pre}->{next} = $cur_item->{next};
    $cur_item->{next}->{pre} = $cur_item->{pre};
    
    delete $this->{items}->{$target_id};
}

## 指定したindex番目の要素を削除
sub remove_by_index {
    my $this = shift;
    my $index = shift;
    
    return if($index < 0 || $index > scalar(keys %{$this->{items}}));
    
    my $cur_item = $this->{items}->{init};
    for ( 0 .. $index ) {
	$cur_item = $cur_item->{next};
    }
    
    ## 前後の要素を更新    
    $cur_item->{pre}->{next} = $cur_item->{next};
    $cur_item->{next}->{pre} = $cur_item->{pre};
    
    undef $cur_item;
}


sub iterator {
    my $this = shift;
    return My::ItemIterator->new($this->{items}->{init});
}


1;
