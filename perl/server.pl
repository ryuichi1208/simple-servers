#!/opt/local/bin/perl -T
use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Date;

my $d = HTTP::Daemon->new(
    LocalAddr => '0.0.0.0',
    LocalPort => shift || 8888
) or die $!;

while ( my ( $c, $peer_addr ) = $d->accept ) {
    while ( my $req = $c->get_request ) {
#        my $header = HTTP::Headers->new( 'Content-Type' => 'text/plain' );
#        my $res = HTTP::Response->new( 200, 'OK', $header, $req->as_string );
        my $header = HTTP::Headers->new( 'Content-Type' => 'application/x-www-form-urlencoded' );
        my $res = HTTP::Response->new( 200, 'OK', $header, get_body() );
        $c->send_response($res);
        print_log($peer_addr, $req, $res);
    }
    $c->close;
    undef($c);
}

# you don't need this unless you need logging
sub print_log {
    use Socket qw/sockaddr_in inet_ntoa/;    # to deparse $peer_addr
    use bytes ();                            # for length
    my ( $peer_addr, $req, $res ) = @_;
    my ( $port, $iaddr ) = sockaddr_in($peer_addr);
    my $remote_addr = inet_ntoa($iaddr);
    my $remote_user = $req->headers->authorization_basic || '-';
    $remote_user =~ s/:.*//o;
    printf qq(%s %s - [%s] "%s %s %s" %d %d\n), 
        $remote_addr, $remote_user, time2str( time() ),
         $req->method, $req->url, $req->protocol,
         $res->code, bytes::length( $res->content );
}

sub get_body {
    my $s = <<EOF;
XXXX=1234
EOF

    return $s;
}

__END__
