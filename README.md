# datadog-lab

> My personal datadog lab. 

This project guides you through setting up observability using **Datadog** for middleware, applications, and Kubernetes infrastructure — including metrics, logs, traces, alerts, and dashboards.

---

## 📋 Requirements

Before you start, make sure you have:

- A **Datadog trial account** (trial lasts 15 days);
- A machine or desktop for installing the Datadog Agent;
- Access to **3 machines or nodes** (can be physical, virtual, or containerized) for a local Kubernetes cluster;

---

## 🖥️ Host Setup

1. **Install Datadog Agent** on your desktop or any machine. (In this step I'm using my own machine. MacOS)
2. Configure the Datadog Agent to collect:
   - APM (Application Performance Monitoring)
   - Logs
   - Metrics
3. Install and configure **Apache HTTP Server** and **RabbitMQ**.
4. Integrate Apache and RabbitMQ with Datadog.
5. Present the standard Datadog dashboards for these middlewares.


### Install datadog-agent
```
datadog-lab|main ⇒ DD_API_KEY=<KEY> DD_SITE="us5.datadoghq.com" bash -c "$(curl -L https://install.datadoghq.com/scripts/install_mac_os.sh)"
```

```
datadog-lab|main ⇒ datadog-agent launch-gui
GUI opened at localhost:5002

http://localhost:5002/
```

```
apache.d|⇒ launchctl list | grep -i datadog
69323	0	com.datadoghq.gui
69731	0	com.datadoghq.agent
```

```
apache.d|⇒ launchctl stop com.datadoghq.agent
apache.d|⇒ launchctl start com.datadoghq.agent
```

### Apache
```
brew install httpd
```

```
httpd|stable ⇒ vim /opt/homebrew/etc/httpd/httpd.conf
Listen 192.168.1.100:80

httpd|stable ⇒ grep -ri "mod_status" httpd.conf
httpd.conf:LoadModule status_module lib/httpd/modules/mod_status.so

cd /opt/homebrew/etc/httpd/extra
extra|stable ⇒ cat httpd-info.conf | grep -v '^#'

<Location /server-status>
    SetHandler server-status
    Require all granted
</Location>

ExtendedStatus On

<Location /server-info>
    SetHandler server-info
    Require all granted
</Location>
```

```
brew services restart httpd
```

### Datadog

```
datadog-agent|⇒ find .  |grep -i "apache"| head -n5
./LICENSES/THIRD-PARTY-Apache-2.0
./etc/conf.d/apache.d
./etc/conf.d/apache.d/auto_conf.yaml
./etc/conf.d/apache.d/conf.yaml
./etc/conf.d/apache.d/.conf.yaml.example.bkp
```

```
vim /opt/datadog-agent/etc/conf.d/apache.d/conf.yaml
```

```
instances:

    ## @param apache_status_url - string - required
    ## Status url of your Apache server.
    #
  - apache_status_url: http://192.168.1.100/server-status?auto


logs:
  - type: file
    path: /opt/homebrew/var/log/httpd/access_log
    source: apache
    service: apache

  - type: file
    path: /opt/homebrew/var/log/httpd/error_log
    source: apache
    service: apache
```

- [Datadog Agent Configuration Files](https://docs.datadoghq.com/agent/configuration/agent-configuration-files/#agent-configuration-directory)
- [Datadog Agent Commands](https://docs.datadoghq.com/agent/configuration/agent-commands/#start-stop-and-restart-the-agent)
- [Apache Access Log](https://phoenixnap.com/kb/apache-access-log)
- [Apache on macOS](https://www.git-tower.com/blog/apache-on-macos)
- [Monitor Apache Web Server Load and Statistics](https://www.tecmint.com/monitor-apache-web-server-load-and-page-statistics/)
- [Apache HTTPD Proxy Setup](https://docs.datadoghq.com/tracing/trace_collection/proxy_setup/httpd/)
- [Kubernetes Log Collection](https://docs.datadoghq.com/containers/kubernetes/log/?tab=datadogoperator)


### RabbitMQ

```
brew update
brew install rabbitmq
...
...
...
Hide these hints with HOMEBREW_NO_ENV_HINTS (see `man brew`).
==> Caveats
==> rabbitmq
Management UI: http://localhost:15672
Homebrew-specific docs: https://rabbitmq.com/install-homebrew.html

To start rabbitmq now and restart at login:
  brew services start rabbitmq
Or, if you don't want/need a background service you can just run:
  CONF_ENV_FILE="/opt/homebrew/etc/rabbitmq/rabbitmq-env.conf" /opt/homebrew/opt/rabbitmq/sbin/rabbitmq-server
```

```
datadog-lab|main ⇒ brew services start rabbitmq
==> Successfully started `rabbitmq` (label: homebrew.mxcl.rabbitmq)

datadog-lab|main ⇒ /opt/homebrew/sbin/rabbitmqctl enable_feature_flag all
Enabling all feature flags ...
```

```
homebrew|stable ⇒ cat ./etc/rabbitmq/rabbitmq-env.conf
CONFIG_FILE=/opt/homebrew/etc/rabbitmq/rabbitmq
NODE_IP_ADDRESS=192.168.1.100
NODENAME=rabbit@192.168.1.100             <= 
RABBITMQ_LOG_BASE=/opt/homebrew/var/log/rabbitmq
PLUGINS_DIR="/opt/homebrew/opt/rabbitmq/plugins:/opt/homebrew/share/rabbitmq/plugins"
```

=>
```
homebrew|stable ⇒ /opt/homebrew/sbin/rabbitmq-plugins enable rabbitmq_management
%Protocol.UndefinedError{protocol: String.Chars, value: {:error, {:node_name, :short}}, description: ""}
```

```
homebrew|stable ⇒ which rabbitmq-plugins
/opt/homebrew/sbin/rabbitmq-plugins
```

* On Apple Silicon Macs, RabbitMQ configuration [file](https://www.rabbitmq.com/docs/install-homebrew#:~:text=On%20Apple%20Silicon%20Macs%2C%20RabbitMQ,new%20configuration%20file%20on%20boot) located at /opt/homebrew/etc/rabbitmq/rabbitmq.conf. The file does not exist by default and must be created by the user. The node then must be restarted so that it picks up the new configuration file on boot.

- [Install RabbitMQ homebrew](https://www.rabbitmq.com/docs/install-homebrew)
- [Password console](https://www.rabbitmq.com/docs/passwords)
- [Monitoring RabbitMQ performance with DataDog](https://www.datadoghq.com/blog/monitoring-rabbitmq-performance-with-datadog/)
- [Setup RabbitMQ Datadog](https://docs.datadoghq.com/integrations/rabbitmq/?tab=host)

---

## ☸️ Kubernetes Setup

1. Build a **local Kubernetes cluster** with 3 nodes using Kind. [Optional]
2. Integrate this Kubernetes cluster with your Datadog account, enabling the Datadog Cluster Agent.
3. Deploy the following applications (Java, .NET, Python) from the directory `apm`:
```
datadog-lab|main ⇒ tree -L 1 apm
apm
├── dotnet
├── java
└── python

4 directories, 0 files
```
4. Instrument these applications to collect and correlate metrics, logs and traces.

```
datadog-lab|main ⇒ helm repo add datadog https://helm.datadoghq.com
"datadog" has been added to your repositories

datadog-lab|main ⇒ helm repo update
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "traefik" chart repository
...Successfully got an update from the "argo" chart repository
...Successfully got an update from the "datadog" chart repository
...Successfully got an update from
```

```
datadog-lab|main ⇒  helm install datadog-operator datadog/datadog-operator
```

https://docs.datadoghq.com/containers/kubernetes/
https://docs.datadoghq.com/containers/kubernetes/installation/?tab=datadogoperator

## APM - trace

- [datadog-operator](https://docs.datadoghq.com/containers/cluster_agent/admission_controller/?tab=datadogoperator)
- [tracing-with-datadog](https://www.datadoghq.com/blog/auto-instrument-kubernetes-tracing-with-datadog/)
- [apm-for-k8s-dd](https://medium.com/@dikshantmali.dev/datadog-apm-for-k8s-everything-you-need-to-know-1fefbbd358d2)
- [tracing](https://www.datadoghq.com/blog/auto-instrument-kubernetes-tracing-with-datadog/)

* python  
https://github.com/DataDog/dd-trace-py/releases

* java  
https://docs.datadoghq.com/tracing/guide/tutorial-enable-java-admission-controller/
https://github.com/DataDog/dd-trace-java/releases

* dotnet  
https://dev.to/kiranrongali/integrate-datadog-with-a-net-application-1gac
https://github.com/DataDog/dd-trace-dotnet/releases/

---

## 🚨 Alerts Setup

1. Create a monitor that triggers an alert when a **pod exceeds 75% memory usage**.
   - Notification via **email**.
2. Create a monitor that triggers an alert when a **pod enters CrashLoopBackOff state**.
   - Notification via **email**.

---

## 📊 Dashboards

Create a Datadog dashboard to quickly identify application errors by combining:

- Logs
- Metrics
- Traces

Include:

- Error rate visualization;
- Currently errors with greater occurence;

---
