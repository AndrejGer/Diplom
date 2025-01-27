#  Дипломная работа по профессии «Системный администратор» `Герасимчук Андрей, группа SYS-35`


Содержание
==========
* [Задача](#Задача)
* [Инфраструктура](#Инфраструктура)
    * [Сайт](#Сайт)
    * [Мониторинг](#Мониторинг)
    * [Логи](#Логи)
    * [Сеть](#Сеть)
    * [Резервное копирование](#Резервное-копирование)
* [Выполнение работы](#Выполнение-работы)

---------

## Задача
Ключевая задача — разработать отказоустойчивую инфраструктуру для сайта, включающую мониторинг, сбор логов и резервное копирование основных данных. Инфраструктура должна размещаться в [Yandex Cloud](https://cloud.yandex.com/) и отвечать минимальным стандартам безопасности: запрещается выкладывать токен от облака в git. Используйте [инструкцию](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#get-credentials).

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

## Инфраструктура
Для развёртки инфраструктуры используйте Terraform и Ansible.  

Не используйте для ansible inventory ip-адреса! Вместо этого используйте fqdn имена виртуальных машин в зоне ".ru-central1.internal". Пример: example.ru-central1.internal  

Важно: используйте по-возможности **минимальные конфигурации ВМ**:2 ядра 20% Intel ice lake, 2-4Гб памяти, 10hdd, прерываемая. 

**Так как прерываемая ВМ проработает не больше 24ч, перед сдачей работы на проверку дипломному руководителю сделайте ваши ВМ постоянно работающими.**

Ознакомьтесь со всеми пунктами из этой секции, не беритесь сразу выполнять задание, не дочитав до конца. Пункты взаимосвязаны и могут влиять друг на друга.

### Сайт
Создайте две ВМ в разных зонах, установите на них сервер nginx, если его там нет. ОС и содержимое ВМ должно быть идентичным, это будут наши веб-сервера.

Используйте набор статичных файлов для сайта. Можно переиспользовать сайт из домашнего задания.

Создайте [Target Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/target-group), включите в неё две созданных ВМ.

Создайте [Backend Group](https://cloud.yandex.com/docs/application-load-balancer/concepts/backend-group), настройте backends на target group, ранее созданную. Настройте healthcheck на корень (/) и порт 80, протокол HTTP.

Создайте [HTTP router](https://cloud.yandex.com/docs/application-load-balancer/concepts/http-router). Путь укажите — /, backend group — созданную ранее.

Создайте [Application load balancer](https://cloud.yandex.com/en/docs/application-load-balancer/) для распределения трафика на веб-сервера, созданные ранее. Укажите HTTP router, созданный ранее, задайте listener тип auto, порт 80.

Протестируйте сайт
`curl -v <публичный IP балансера>:80` 

### Мониторинг
Создайте ВМ, разверните на ней Zabbix. На каждую ВМ установите Zabbix Agent, настройте агенты на отправление метрик в Zabbix. 

Настройте дешборды с отображением метрик, минимальный набор — по принципу USE (Utilization, Saturation, Errors) для CPU, RAM, диски, сеть, http запросов к веб-серверам. Добавьте необходимые tresholds на соответствующие графики.

### Логи
Cоздайте ВМ, разверните на ней Elasticsearch. Установите filebeat в ВМ к веб-серверам, настройте на отправку access.log, error.log nginx в Elasticsearch.

Создайте ВМ, разверните на ней Kibana, сконфигурируйте соединение с Elasticsearch.

### Сеть
Разверните один VPC. Сервера web, Elasticsearch поместите в приватные подсети. Сервера Zabbix, Kibana, application load balancer определите в публичную подсеть.

Настройте [Security Groups](https://cloud.yandex.com/docs/vpc/concepts/security-groups) соответствующих сервисов на входящий трафик только к нужным портам.

Настройте ВМ с публичным адресом, в которой будет открыт только один порт — ssh.  Эта вм будет реализовывать концепцию  [bastion host]( https://cloud.yandex.ru/docs/tutorials/routing/bastion) . Синоним "bastion host" - "Jump host". Подключение  ansible к серверам web и Elasticsearch через данный bastion host можно сделать с помощью  [ProxyCommand](https://docs.ansible.com/ansible/latest/network/user_guide/network_debug_troubleshooting.html#network-delegate-to-vs-proxycommand) . Допускается установка и запуск ansible непосредственно на bastion host.(Этот вариант легче в настройке)

### Резервное копирование
Создайте snapshot дисков всех ВМ. Ограничьте время жизни snaphot в неделю. Сами snaphot настройте на ежедневное копирование.

---------

# Выполнение работы

На первом этапе работы для развертывания инфраструктуры в Yandex Cloud используется **terraform**. 

Запускаем процесс поднятия инфраструктуры командой `terraform apply`, выводится список ip адресов и fqdn имён всех виртуальных машин.

![1](https://github.com/AndrejGer/Diplom/blob/main/img/1.png)

Проверяем в web консоли Yandex Cloud параметры созданной инфраструктуры

![2](https://github.com/AndrejGer/Diplom/blob/main/img/2.png)

### Application load balancer (Балансировщик нагрузки)

Load Balancer Target Group с созданными машинами nginx1 и nginx2

![3](https://github.com/AndrejGer/Diplom/blob/main/img/3.png)

Создание Backend Group и настройка backends на target group

![4](https://github.com/AndrejGer/Diplom/blob/main/img/4.png)

![5](https://github.com/AndrejGer/Diplom/blob/main/img/5.png)

Создание HTTP router

![6](https://github.com/AndrejGer/Diplom/blob/main/img/6.png)

Создание Application load balancer для распределения трафика на веб-сервера

![7](https://github.com/AndrejGer/Diplom/blob/main/img/7.png)

![9](https://github.com/AndrejGer/Diplom/blob/main/img/9.png)

### Сеть

Создана 1 VPC с публичными и внутренними подсетями, таблицей маршрутизации для доступа к интернету ВМ находящихся внутри сети за
Бастионом, который будет выступать в роли интернет-шлюза. Сервера web, Elasticsearch находятся в приватной подсети.
Сервера Zabbix, Kibana, application load balancer - в публичной подсети.

![10](https://github.com/AndrejGer/Diplom/blob/main/img/10.png)

### Security Groups
Произведена настройка Security Groups соответствующих сервисов на входящий трафик только к нужным портам.
На ВМ bastion открыт только один порт — ssh

![11](https://github.com/AndrejGer/Diplom/blob/main/img/11.png)

### Резервное копирование
Созданы snapshot дисков всех ВМ на ежедневное копирование. Время жизни снапшотов - одна неделя.

![12](https://github.com/AndrejGer/Diplom/blob/main/img/12.png)


На втором этапе для установки и настройки всех сервисов используется **Ansible**.

Подключение ansible к серверам через bastion host реализовано с помощью ProxyCommand  
`ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -q andrej@bastion"'`

Содержимое файла inventory.ini, используются fqdn имена виртуальных машин

![13](https://github.com/AndrejGer/Diplom/blob/main/img/13.png)

Проверка генерации инвентаря Ansible

![14](https://github.com/AndrejGer/Diplom/blob/main/img/14.png)

Проверяем доступность всех хостов с помощью Ansible ping   
`ansible all -m ping`

![14](https://github.com/AndrejGer/Diplom/blob/main/img/ping1.png)

Дополнительно проверяем доступ к хостам через ping.yml

![14](https://github.com/AndrejGer/Diplom/blob/main/img/ping2.png)

### Сайт

#### Установка NGINX

запускаем playbook nginx.yml

![nginx](https://github.com/AndrejGer/Diplom/blob/main/img/nginx.png)

В терминале прорверяем через `curl -v 158.160.143.86:80`

![15](https://github.com/AndrejGer/Diplom/blob/main/img/15.png)

Проверяем доступность сайта в браузере по публичному ip адресу балансировщика

![16](https://github.com/AndrejGer/Diplom/blob/main/img/16.png)

Как видим backend ip меняется с `nginx1 (192.168.10.10)` на `nginx2 (192.168.20.10)`, значит балансировщик распеределяет трафик между веб-серверами.

![17](https://github.com/AndrejGer/Diplom/blob/main/img/17.png)

![18](https://github.com/AndrejGer/Diplom/blob/main/img/18.png)

### Стек ELK для сбора логов

#### Установка Kibana Kibana.yml

![18](https://github.com/AndrejGer/Diplom/blob/main/img/kibana.png)

#### Установка Filebeat Filebeat.yml

![18](https://github.com/AndrejGer/Diplom/blob/main/img/filebeat.png)

#### Установка Elasticsearch Elastic.yml

![18](https://github.com/AndrejGer/Diplom/blob/main/img/elastic.png)

На хосте elasticsearch проверяем работу кластера

```
ssh -J andrej@158.160.147.238 andrej@elastic  
curl -X GET 'localhost:9200/_cluster/health?pretty'
```

![19](https://github.com/AndrejGer/Diplom/blob/main/img/19.png)

#### Kibana доступен по http://158.160.138.91:5601/

![20](https://github.com/AndrejGer/Diplom/blob/main/img/20.png)

Проверяем в Kibana что Filebeat доставляет access.log, error.log в Elasticsearch с серверов nginx1 и nginx2
Как видно логи от обоих веб-серверов приходят

![21](https://github.com/AndrejGer/Diplom/blob/main/img/21.png)

### Мониторинг

#### Установка zabbix-server, базы данных PostgreSQL и других зависимоcтей Zabbix.yml

![zabbix-server](https://github.com/AndrejGer/Diplom/blob/main/img/zabbix-server.png)

#### Установка Zabbix-agent на web сервера Zabbix-agent.yml

![zabbix-agent](https://github.com/AndrejGer/Diplom/blob/main/img/zabbix-agent.png)

#### Zabbix-server доступен по http://158.160.138.120/zabbix/ 	
#### Username: Admin     
#### Password: zabbix

Доступность zabbix-агентов

Настройка дешбордов с отображением метрик
