package test::My::List;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use My::List;

sub init : Test(1) {
    new_ok 'My::List';
}

sub list01 : Tests {
    my $list = My::List->new;
    
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
    my $list = My::List->new;
    
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
        
    $iter->init;
    cmp_ok $iter->next->value, "eq", $lists[0];
    isnt $iter->next->value, [1,2];
    isnt $iter->next->value, { a => 2, b => 2 };
    
    can_ok $iter, qw(has_next next init);
    can_ok $list, qw(append iterator);
}

__PACKAGE__->runtests;

1;
