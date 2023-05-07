import axios from 'axios';


(async () => {
    setInterval(() => {
        axios.get('http://localhost')
            .then(v => console.log(v))
            .catch(e => console.error(e))
    }, 5)
})();
