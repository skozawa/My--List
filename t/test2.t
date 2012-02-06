package test::My::DoublyList;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Test::Exception;
use My::DoublyList;

BEGIN { 
    use_ok 'My::ListItem';
    use_ok 'My::Iterator';
    use_ok 'My::Aggregate';
    use_ok 'My::ItemIterator';
}

sub init : Test(1) {
    new_ok 'My::DoublyList';
}

sub list01 : Tests {
    my $list = My::DoublyList->new;
    
    my @lists = ("Hello", "World", 2011);
    foreach (@lists) {
	$list->append($_);
    }
    
    my $iter = $list->iterator;
    my @get_lists;
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], [@lists];
    
    my @lists2 = ("Hello", "2012");
    foreach (@lists2) {
	$list->append($_);
    }
    
    my @get_lists2;
    $iter->init;
    while ($iter->has_next) {
	push @get_lists2, $iter->next->value;
    }
    is_deeply [@get_lists2], [@lists,@lists2];
}

sub list02 : Tests {
    my $list = My::DoublyList->new;
    
    my @lists = ("Hello", [1,2,3], { a => 1, b => 2}, undef);
    foreach (@lists) {
	$list->append($_);
    }
    
    my $iter = $list->iterator;
    my @get_lists;
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], [@lists];
    
    dies_ok { $iter->next; } 'dies_ok test';
        
    $iter->init;
    cmp_ok $iter->next->value, "eq", $lists[0];
    isnt $iter->next->value, [1,2];
    isnt $iter->next->value, { a => 2, b => 2 };
    
    can_ok $iter, qw(has_next next init);
    can_ok $list, qw(append iterator append_item append_by_index remove remove_by_index);
}

sub list03 : Tests {
    my $list = My::DoublyList->new;
    
    my @lists = ("a", "a", "e", "h", "n", "t");
    $list->append($lists[$_]) for 0 .. 2; # aae
    $list->append($lists[3], "init"); # aae -> haae
    $list->append($lists[4], 1); # haae -> hanae
    $list->append($lists[5], 2); # hanae -> hanate
    
    my $iter = $list->iterator;
    my @get_lists;
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], ["h","a","n","a","t","e"];
    
    $list->remove(6); # hanate -> hanae
    $list->remove_by_index(4); # hanae -> hana
    
    $iter->init;
    @get_lists = ();
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], ["h","a","n","a"];
    
    $list->append_by_index($lists[5], 1); # hana -> hatna
    $list->append_by_index($lists[2], 2); # hatna -> hatena
    
    $iter->init;
    @get_lists = ();
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], ["h","a","t","e","n","a"];
    
    ## 存在しない要素の場合は削除されない
    $list->remove(100);
    $list->remove_by_index(100);
    
    $iter->init;
    @get_lists = ();
    while ($iter->has_next) {
	push @get_lists, $iter->next->value;
    }
    is_deeply [@get_lists], ["h","a","t","e","n","a"];
}

__PACKAGE__->runtests;


1;
