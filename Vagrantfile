Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"

  # Kubernetes cluster VM
  config.vm.define "k8s" do |k8s|
    k8s.vm.hostname = "k8s"
    k8s.vm.network "private_network", ip: "192.168.56.11"
    k8s.vm.network "private_network", ip: "192.168.56.12"
    k8s.vm.network "private_network", ip: "192.168.56.13"
    k8s.vm.network "private_network", ip: "192.168.56.14"
    k8s.vm.network "private_network", ip: "192.168.56.15"
  
    # Script de instalação do k8s
    k8s.vm.provision "shell", path: "k8s.sh"

    # Script de criação do certificado https
    k8s.vm.provision "shell", path: "generate_cert.sh"
    
    # Compartilha a pasta C:\Users\Arklok\lab-k8s-vagrant no Windows com /vagrant_data na VM
    k8s.vm.synced_folder "C:/Users/Arklok/lab-k8s-vagrant", "/vagrant_data"
    
    # Adicionando memória e CPU
    k8s.vm.provider "virtualbox" do |vb|
      vb.memory = "5096"
      vb.cpus = 2
    end
  end
end
