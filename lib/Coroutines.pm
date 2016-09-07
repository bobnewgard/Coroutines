unit module Coroutines;

my @coroutines;

sub coroutines_avail is export returns Int {
    return @coroutines.elems();
}

sub async(&coroutine) is export {
    my @a = lazy gather {
        &coroutine();
        take False;
    }

    @coroutines.push(@a);
}

#= must be called from inside a coroutine
sub yield is export {
    take True;
}

#= should be called from mainline code
sub schedule is export {
    my $cnt = coroutines_avail();
    my $i   = 0;
    my @ret = Empty;

    if ($cnt < 1) {
        return;
    }

    loop ($i = 0; $i < $cnt ; $i++) {
        @ret[$i] = @coroutines[$i].shift();
    }

    loop ($i = $cnt ; $i > 0 ; $i--) {
        my $j = $i - 1;

        if (@ret[$j] == False)
        {
            @coroutines.splice($j, 1);
        }
    }
}
