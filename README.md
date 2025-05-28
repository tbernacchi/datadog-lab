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

1. **Install Datadog Agent** on your desktop or any machine.
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

https://docs.datadoghq.com/agent/configuration/agent-configuration-files/#agent-configuration-directory
https://docs.datadoghq.com/agent/configuration/agent-commands/#start-stop-and-restart-the-agent
https://phoenixnap.com/kb/apache-access-log
https://www.git-tower.com/blog/apache-on-macos 
https://www.tecmint.com/monitor-apache-web-server-load-and-page-statistics/
https://docs.datadoghq.com/tracing/trace_collection/proxy_setup/httpd/
https://docs.datadoghq.com/containers/kubernetes/log/?tab=datadogoperator

---

## ☸️ Kubernetes Setup

1. Build a **local Kubernetes cluster** with 3 nodes using Kind. [Optional]
2. Integrate this Kubernetes cluster with your Datadog account, enabling the Datadog Cluster Agent.
3. Deploy the following applications (Java, .NET, Python) from the directory `apm`:
```apm
├── dotnet
├── java
└── python
```
4. Instrument these applications to collect and correlate metrics, logs and traces.

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

## 🎯 Goal

Enable full observability and monitoring for middleware and Kubernetes applications, improving detection and response to operational issues using Datadog.
