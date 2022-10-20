export default {
  methods: {
    useInstallationName(str = '', installationName) {
      return str.replace(/Ellixar Chat/g, installationName);
    },
  },
};
