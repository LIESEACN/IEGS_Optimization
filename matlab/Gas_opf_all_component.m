% ����ѹ����
gascase = case_4_gas;
nb = size(gascase.bus,1);
nbr = size(gascase.branch,1);
nc = size(gascase.compressors,1);
ns = size(gascase.source,1);
opt = sdpsettings('solver','cplex','verbose',1,'savesolveroutput',1);
opt.cplex.exportmodel = 'model.lp'

pressuremax = gascase.bus(:,4).^2;
pressuremin = zeros(nb,1);
total_source = sum(gascase.source(:,3));

source = sdpvar(ns,1);
flow = sdpvar(nbr,1);
pressure = sdpvar(nb,1);    % x^2

% ѹ������С
commin = 1;
commax = 10;

% ��������
[A,B,w] = relation(gascase);
% ����ѹ����ֻ��ҪA,w

% ����ƽ��Լ��
constraints_balance = [A*flow + w*source - gascase.bus(:,3) == 0];

% ��ԴԼ��
constraints_source = [zeros(ns,1)<= source];

% ��������Լ��
constraints_capacity_l = [-gascase.branch(:,5)-flow<=0];   % linear
constraints_capacity_u = [flow-gascase.branch(:,5)<=0];  % linear

% ����-��ѹ��ϵԼ��,��ѹѹ����Լ��,͹Լ��
% arc(i,j) = pipe(i,j)+valve(i,j)+compressor(i,j)
% ������������Լ����0-1������bin(nbr,2)
% ��֤͹�ɳڣ������м������sdp(nbr,1)
% ��ѹ��������Ҫ���뿪�ر���
% switch=binvar(v,1);
y = binvar(nbr,2);
gama = sdpvar(nbr,1);
constraints_pressure = [2000*ones(nb, 1) <= pressure <= pressuremax];
for i = 1:nbr
    f = gascase.branch(i, 1);
    t = gascase.branch(i, 2);
    if gascase.branch(i,4) == 0
        % pipe flow constraints
        constraints_pressure = [constraints_pressure, -(1-y(i,1))*total_source<=flow(i)<=(1-y(i,2))*total_source];
        constraints_pressure = [constraints_pressure, (1-y(i,1))*(pressuremin(f)-pressuremax(t))<=pressure(f)-pressure(t)<=(1-y(i,2))*(pressuremax(f)-pressuremin(t))];
        constraints_pressure = [constraints_pressure, gama(i) >= (pressure(t) - pressure(f)) + (pressuremin(f) - pressuremax(t)) * (y(i, 1) - y(i, 2) + 1)];
        constraints_pressure = [constraints_pressure, gama(i) >= (pressure(f) - pressure(t)) + (pressuremax(f) - pressuremin(t)) * (y(i, 1) - y(i, 2) - 1)];
        constraints_pressure = [constraints_pressure, gama(i) <= (pressure(t) - pressure(f)) + (pressuremax(f) - pressuremin(t)) * (y(i, 1) - y(i, 2) + 1)];
        constraints_pressure = [constraints_pressure, gama(i) <= (pressure(f) - pressure(t)) + (pressuremin(f) - pressuremax(t)) * (y(i, 1) - y(i, 2) - 1)];
        constraints_pressure = [constraints_pressure, gama(i) >= flow(i)^2 / gascase.branch(i, 3)^2];
        constraints_pressure = [constraints_pressure, y(i,1)+y(i,2)==1];
    elseif gascase.branch(i,4) == 1
        % compressors constraints
        % flow > 0
        constraints_pressure = [constraints_pressure, pressure(f) * commin + (1 - y(i, 1)) * (pressuremin(t) - pressuremax(f) * commin) <= pressure(t) ...
                                <= pressure(f) * commax + (1 - y(i, 1)) * (pressuremax(t) - pressuremin(f) * commax)];
        % flow < 0
        constraints_pressure = [constraints_pressure, pressure(t) * commin + (1 - y(i, 2)) * (pressuremin(f) - pressuremax(t) * commin) <= pressure(f) ...
                                <= pressure(t) * commax + (1 - y(i, 2)) * (pressuremax(f) - pressuremin(t) * commax)];
        constraints_pressure = [constraints_pressure, y(i, 1) + y(i, 2) == 1];
    %{
    else
        constraints_pressure = [constraints_pressure, pressure(f) * vavmin + (2 - y(i, 1) - switch(k,1)) * (pressuremin(t) - pressuremax(f) * vavmin) <= pressure(t) ...
                                <= pressure(f) * vavmax + (2 - y(i, 1) - switch(k,1)) * (pressuremax(t) - pressuremin(f) * vavmax)];
        constraints_pressure = [constraints_pressure, pressure(t) * vavmin + (2 - y(i, 2) - switch(k, 1)) * (pressuremin(f) - pressuremax(t) * vavmin) <= pressure(f) ...
                                <= pressure(t) * vavmax + (2 - y(i, 2) - switch(k, 1)) * (pressuremax(f) - pressuremin(t) * vavmax)];
        constraints_pressure = [constraints_pressure, y(i, 1) + y(i, 2) == 1];
    %}
    end
end

constraints = constraints_balance + constraints_source + constraints_capacity_l + constraints_capacity_u + constraints_pressure;


F = gascase.cost'*source;

sol = optimize(constraints,F,opt);