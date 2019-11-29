int listenfd = socket(AF_INET, SOCK_STREAM, 0);
if(listenfd == -1) {
    std::cout << "socket() failed." << std::endl;
    exit(1);
}

int optval = 1;
if(setsockopt(listenfd, SOL_SOCKET, SO_REUSEADDR, &optval, sizeof(optval)) == -1) {
    std::cout << "setsockopt() failed." << std::endl;
    close(listenfd);
    return -1;
}

int port = 5000;
struct sockaddr_in serv_addr;

memset(&serv_addr, 0, sizeof(serv_addr));

serv_addr.sin_family = AF_INET;
serv_addr.sin_addr.s_addr = htonl(INADDR_ANY);
serv_addr.sin_port = htons(port);


if(bind(listenfd, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1) {
    std::cout << "bind() failed.(" << errno << ")" << std::endl;
    close(listenfd);
    return -1;
}

if(listen(listenfd, SOMAXCONN) == -1) {
    std::cout << "listen() failed." << std::endl;
    close(this->listenfd);
    return -1;
}
