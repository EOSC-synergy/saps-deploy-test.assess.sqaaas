(mkdir /im
cat <<EOF >> /im/auth.dat
# InfrastructureManager auth
type = InfrastructureManager; username = %s; password = %s
# OpenStack site using standard user, password, tenant format

id = incd; type = OpenStack; host = https://stratus.ncg.ingrid.pt:5000; username = %s; password = %s; tenant = eosc-synergy; domain = default; auth_version = 3.x_password

EOF
if [ -z "$IM_USER" ] || [ -z "$IM_PASS" ] || [ -z "$OPENSTACK_USER" ] || [ -z "$OPENSTACK_PASS" ]; then
  echo 'One or more credential variables are undefined (required: IM_USER, IM_PASS, OPENSTACK_USER, OPENSTACK_PASS)'
  exit 1
fi
printf "$(cat /im/auth.dat)" "${IM_USER}" "${IM_PASS}" "${OPENSTACK_USER}" "${OPENSTACK_PASS}" > /im/auth.dat
echo "Generated auth.dat file:"
ls -l /im/auth.dat
echo

mkdir -p /etc/ec3/templates
cp -rf github.com/orviz/saps-deploy-test/ec3_recipe/* /etc/ec3/templates
cp ec3_recipe/kubernetes-brazil.radl /etc/ec3/templates
ec3 launch sqaaas_ec3_cluster kubernetes-brazil nfs-saps nfs -a "/im/auth.dat" -u https://appsgrycap.i3m.upv.es:31443/im/ -y
ec3 show sqaaas_ec3_cluster -r
ec3 destroy sqaaas_ec3_cluster --force -y
)