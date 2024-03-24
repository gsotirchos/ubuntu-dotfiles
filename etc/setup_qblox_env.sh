main() {
    local env_name="${1-qblox}"
    conda create -n "${env_name}" python=3.9
    mamba activate "${env_name}"
    pip install qblox-instruments
    #ipython kernel install --user --name "${env_name}"
    mamba deactivate
    mamba clean -y --all
}

main "$@"
unset main
