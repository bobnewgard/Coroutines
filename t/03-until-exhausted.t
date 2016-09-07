use Coroutines;
use Test;
plan 1;

my @results;

async {
    @results.push: 1;
    yield();
    @results.push: 3;
    yield();
    @results.push: 5;
}

async {
    @results.push: 2;
    yield();
    @results.push: 4;
    yield();
    @results.push: 6;
    yield();
    @results.push: 7;
}


loop
{
    if (coroutines_avail())
    {
        schedule();
    }
    else
    {
        last;
    }
}

is @results.join(','), '1,2,3,4,5,6,7', 'yay, correct order';
