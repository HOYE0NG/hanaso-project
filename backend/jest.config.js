module.exports = {
    transform: {
        '^.+\\.jsx?$': 'babel-jest',
    },
    setupFilesAfterEnv: ['regenerator-runtime/runtime'],
};
