#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'HTML::Image::Save' );
}

diag( "Testing HTML::Image::Save $HTML::Image::Save::VERSION, Perl $], $^X" );
