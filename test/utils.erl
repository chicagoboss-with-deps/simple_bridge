-module (utils).
-compile(export_all).

make_inets_bridge() ->
	% Construct the inets bridge...
	{ok, [InetsRequest] } = file:consult("data/inets_request_data"),
	{ok, Socket} = gen_tcp:connect(?PEER_IP, ?PEER_PORT, []),
	InetsRequest1 = inject_socket(InetsRequest, Socket),
	InetsBridge = request_bridge:make(inets_request_bridge, InetsRequest1),
	InetsBridge.

% inject_socket(Term, FakeSocket) ->
% Given a term and a fake socket, replace any instances of 'socket'
% in that term with the fake socket.   
inject_socket([], _) -> [];
inject_socket(socket, Socket) -> Socket;
inject_socket([socket|T], Socket) -> [Socket|T];
inject_socket([H|T], Socket) -> [H|inject_socket(T, Socket)];
inject_socket(Term, Socket) when is_tuple(Term) ->
	List = tuple_to_list(Term),
	List1 = inject_socket(List, Socket),
	list_to_tuple(List1);
inject_socket(Other, _) -> Other.

